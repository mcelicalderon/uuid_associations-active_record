# frozen_string_literal: true

RSpec.describe 'has_many associations' do
  let(:post)    { Post.create!(content: 'test', uuid: SecureRandom.uuid) }
  let(:user)    { User.create!(name: 'Alice', uuid: SecureRandom.uuid) }
  let(:comment) { Comment.create!(body: 'My comment', uuid: SecureRandom.uuid) }

  describe 'writers' do
    before do
      user.post_uuids = [post.uuid]
      post.comment_uuids = [comment.uuid]
    end

    it 'defines association_uuids=' do
      expect(user.post_ids).to    eq(Post.pluck(:id))
      expect(post.comment_ids).to eq(Comment.pluck(:id))
    end
  end

  describe 'readers' do
    before { Post.create!(content: 'test', user: user, uuid: SecureRandom.uuid) }

    it 'defines association_uuids' do
      expect(user.post_uuids).to eq(Post.pluck(:uuid))
    end
  end
end
