import pytest
import moto
import boto3

from src.common.repo.base_repo import BaseRepo, Item

@pytest.fixture
def mock_client():
    with moto.mock_aws():
        yield boto3.client('dynamodb')

class DummyItem(Item):
    a: int
    b: str

class DummyRepo(BaseRepo):
    ITEM_TYPE = DummyItem
    TABLE_NAME = 'dummy_table'

class Test_BaseRepo():

    def test__serialize(self):
        repo = DummyRepo(mock_client)
        item = DummyItem(id='test_id', a=123, b='123')
        actual = repo._serialize_item(item)
        expected = {
            'id': {'S': 'test_id'},
            'a': {'N': '123'},
            'b': {'S': '123'}
        }
        assert actual == expected

    def test__deserialize(self, mock_client):
        repo = DummyRepo(mock_client)
        dynamodb_item = {
            'id': {'S': 'test_id'},
            'a': {'N': '123'},
            'b': {'S': '123'}
        }
        expected = DummyItem(id='test_id', a=123, b='123')
        actual = repo._deserialize_item(dynamodb_item)
        assert actual == expected
