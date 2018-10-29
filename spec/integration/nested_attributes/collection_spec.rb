RSpec.describe 'nested attributes for collection' do
  context 'when nested association has no UUID column' do
    let(:pet) { Pet.create!(name: 'Simba') }

    it 'does not call UUID finder' do
      expect(UuidAssociations::ActiveRecord::NestedAttributes::UuidFinder).not_to receive(:replaced_uuids_with_ids)

      pet.update(toys_attributes: [{ name: 'no-uuid-here ;)' }])
    end
  end

  context 'when creating a new record' do
    it 'creates nested resources when not existing UUID is passed' do
      expect do
        Post.create!(
          uuid: SecureRandom.uuid,
          content: 'post',
          comments_attributes: [
            body: 'New comment',
            uuid: SecureRandom.uuid
          ]
        )
      end.to change(Post, :count).from(0).to(1)
         .and change(Comment, :count).from(0).to(1)

      expect(Post.first.comments.count).to eq(1)
    end

    it 'creates nested resources when no UUID or ID is passed' do
      expect do
        Post.create!(
          uuid: SecureRandom.uuid,
          content: 'post',
          comments_attributes: [
            body: 'New comment'
          ]
        )
      end.to change(Post, :count).from(0).to(1)
         .and change(Comment, :count).from(0).to(1)

      expect(Post.first.comments.count).to eq(1)
    end
  end

  context 'when updating existing records' do
    let(:comment_uuid) { SecureRandom.uuid }
    let(:post)         { Post.create!(uuid: SecureRandom.uuid, content: 'My post') }
    let!(:comment)     { Comment.create!(post: post, body: 'My comment', uuid: comment_uuid) }

    it 'updates nested records when a UUID is passed and no ID' do
      expect do
        post.update(comments_attributes: [{ uuid: comment.uuid, body: 'updated comment' }])
        comment.reload
      end.to change(comment, :body).from('My comment').to('updated comment')
    end

    it 'updates nested records by ID if ID is passed' do
      expect do
        post.update(comments_attributes: [{ id: comment.id, uuid: 'new-uuid', body: 'updated comment' }])
        comment.reload
      end.to change(comment, :body).from('My comment').to('updated comment')
         .and change(comment, :uuid).from(comment_uuid).to('new-uuid')
    end
  end
end
