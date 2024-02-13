from typing import Generic, Type, TypeVar
from uuid import uuid4
from abc import ABC

from pydantic import BaseModel
from boto3.dynamodb.types import TypeDeserializer, TypeSerializer

from common.utils import get_client

class Item(BaseModel):
    id: str = uuid4().hex
T = TypeVar('T', bound=Item)
TableItem = dict[str, dict[str, str]]


class BaseRepo(Generic[T]): # TODO unittest
    ITEM_TYPE: Type[T]
    TABLE_NAME: str

    def __init__(self, client=get_client('dynamodb')):
        assert getattr(self, 'ITEM_TYPE', None) is not None, 'ITEM_TYPE needs to be set on the concrete class'
        self._client = client
        self._serializer = TypeSerializer()
        self._deserializer = TypeDeserializer()

    def _deserialize_item(self, table_item: TableItem) -> T:
        """
        Deserialize the item that the repo is generic over from the dynamodb representation.
        """
        deserialized = { k: self._deserializer.deserialize(v) for k, v in table_item.items() }
        return self.ITEM_TYPE.model_validate(deserialized)

    def _deserialize_many(self, items: list[TableItem]) -> list[T]:
        """
        Deserialize a list of dynamo represenations into Items.
        """
        return [self._deserialize_item(item) for item in items]

    def _serialize_item(self, item: T) -> TableItem:
        """
        Serialize the item that the repo is generic over into the dynamodb representation.
        """
        serialized = { k: self._serializer.serialize(v) for k, v in item.model_dump().items() }
        return serialized

    def _serialize_many(self, items: list[T]) -> list[TableItem]:
        """
        Serialize a list of Items into dynamo representations.
        """
        return [self._serialize_item(item) for item in items]

    def scan(self) -> list[T]:
        """
        Scan the table and return a list of all items.
        """
        table_items: list[TableItem] = self._client.scan(TableName=self.TABLE_NAME)['Items'] # type: ignore
        items: list[T] = self._deserialize_many(table_items) # type: ignore
        return items
    
    def get_item(self, id: str) -> T:
        """
        Get an item from the dynamo table.
        """
        found = self._client.get_item(TableName=self.TABLE_NAME, Key={'id': {'S': id}})['Item']
        return self._deserialize_item(found)
    
    def put_item(self, item: T):
        """
        Put an item into the dynamo table.
        """
        dynamo_item = self._serialize_item(item)
        return self._client.put_item(TableName=self.TABLE_NAME, Item=dynamo_item) # type: ignore

    def batch_put_items(self, items: list[T]):
        """
        Batch put items into dynamo table.
        """
        put_requests = [{'PutRequest': {'Item': self._serialize_item(item)}} for item in items]
        return self._client.batch_write_item(RequestItems={self.TABLE_NAME: put_requests}) # type: ignore
    
    def delete_item(self, item_id: str):
        """
        Delete an item from the dynamo table.
        """
        return self._client.delete_item(TableName=self.TABLE_NAME, Key={'id': {'S': item_id}}) # type: ignore
