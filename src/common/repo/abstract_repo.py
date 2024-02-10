from dataclasses import dataclass
from abc import ABC
from common.utils import get_client

@dataclass
class Item(ABC):
    id: str

TableItem = dict[str, dict[str, str]]

DYNAMO_DATA_TYPES = {
    str: 'S',
    int: 'N',
    float: 'N',
    dict: 'M',
    list: 'L',
    set[str]: 'SS',
    set[int]: 'SN',
    set[float]: 'SN',
}

class AbstractRepo[T: Item](ABC): # TODO unittest
    TABLE_NAME: str
    ITEM_TYPE: type[T]

    def __init__(self, client=get_client('dynamodb')):
        self._client = client

    def _deserialize_item(self, table_item: TableItem) -> T:
        """
        Deserialize the item that the repo is generic over from the dynamodb representation.
        """
        init_kwargs = {}
        for k, v in table_item.items():
            data_type = self.ITEM_TYPE.__dict__['__dataclass_fields__'][k].type
            init_kwargs[k] = data_type(v[DYNAMO_DATA_TYPES[data_type]])
        item = self.ITEM_TYPE(
            **init_kwargs # type: ignore
        )
        return item

    def _deserialize_many(self, items: list[TableItem]) -> list[T]:
        """
        Deerialize a list of dynamo represenations into Items.
        """
        return [self._deserialize_item(item) for item in items]

    def _serialize_item(self, item: Item) -> TableItem:
        """
        Serialize the item that the repo is generic over into the dynamodb representation.
        """
        return {
            'id': {'S': item.id},
            **{
                k: {DYNAMO_DATA_TYPES[type(v)]: str(v)} for k, v in vars(item).items()
            }
        }

    def _serialize_many(self, items: list[Item]) -> list[TableItem]:
        """
        Serialize a list of Items into dynamo representations.
        """
        return [self._serialize_item(item) for item in items]

    def scan(self) -> list[Item]:
        """
        Scan the table and return a list of all items.
        """
        table_items: list[TableItem] = self._client.scan(TableName=self.TABLE_NAME)['Items'] # type: ignore
        items: list[Item] = self._deserialize_many(table_items) # type: ignore
        return items
    
    def get_item(self, id: str) -> T:
        """
        Get an item from the dynamo table.
        """
        found = self._client.get_item(TableName=self.TABLE_NAME, Key={'id': {'S': id}})['Item']
        return self._deserialize_item(found)
    
    def put_item(self, item: Item):
        """
        Put an item into the dynamo table.
        """
        dynamo_item = self._serialize_item(item)
        return self._client.put_item(TableName=self.TABLE_NAME, Item=dynamo_item) # type: ignore

    def batch_put_items(self, items: list[Item]):
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
