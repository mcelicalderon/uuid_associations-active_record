require 'uuid_associations/active_record/nested_attributes/uuid_finder'

RSpec.describe UuidAssociations::ActiveRecord::NestedAttributes::UuidFinder do
  describe '.replaced_uuids_with_ids' do
    subject { described_class.replaced_uuids_with_ids(klass, attribute_collection) }

    let(:post)    { Post.create!(content: 'content', uuid: SecureRandom.uuid) }
    let(:comment) { Comment.create!(post: post, body: 'my comment', uuid: SecureRandom.uuid) }
    let(:klass)   { Comment }

    context 'when attributes come as an array' do
      context 'when UUID is present, but ID is not' do
        let(:attribute_collection) { [{ uuid: comment.uuid, body: 'updated comment' }] }

        it { is_expected.to contain_exactly(id: comment.id, body: 'updated comment') }

        context 'when record with specified UUID does not exist on the sytem' do
          let(:attribute_collection) { [{ uuid: SecureRandom.uuid, body: 'new comment :/' }] }

          it { is_expected.to match_array(attribute_collection) }
        end
      end

      context 'when both UUID and ID are present' do
        let(:attribute_collection) do
          [
            { uuid: comment.uuid, id: comment.id, body: 'updated comment' },
            { body: 'new comment' }
          ]
        end

        it do
          is_expected.to contain_exactly(
            { uuid: comment.uuid, id: comment.id, body: 'updated comment' },
            { body: 'new comment' }
          )
        end
      end
    end

    context 'when attributes come as a hash' do
      context 'when UUID is present, but ID is not' do
        let(:attribute_collection) { { first: { uuid: comment.uuid, body: 'updated comment' } } }

        it { is_expected.to contain_exactly(id: comment.id, body: 'updated comment') }

        context 'when record with specified UUID does not exist on the sytem' do
          let(:attribute_collection) { { first: { uuid: SecureRandom.uuid, body: 'new comment :/' } } }

          it { is_expected.to match_array(attribute_collection.values) }
        end
      end

      context 'when both UUID and ID are present' do
        let(:attribute_collection) do
          {
            first: { uuid: comment.uuid, id: comment.id, body: 'updated comment' },
            second: { body: 'new comment' }
          }
        end

        it do
          is_expected.to contain_exactly(
            { uuid: comment.uuid, id: comment.id, body: 'updated comment' },
            { body: 'new comment' }
          )
        end
      end
    end
  end
end