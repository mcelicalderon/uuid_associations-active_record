# frozen_string_literal: true

RSpec.describe 'belongs_to associations' do
  let(:user) { User.create!(name: 'Alice', uuid: SecureRandom.uuid) }

  describe 'writers' do
    it 'defines association_uuid=' do
      post = Post.create!(user_uuid: user.uuid, content: 'my first comment')

      expect(post.user_id).to eq(user.id)
    end

    context 'when provided a nil value' do
      it 'sets a nil value' do
        post = Post.create!(user_uuid: nil, content: 'my first comment')

        expect(post.user_id).to be_nil
      end
    end
  end

  describe 'readers' do
    let(:post) { Post.create!(content: 'test', user: user) }

    it 'defines association_uuid' do
      expect(post.user_uuid).to eq(user.uuid)
    end
  end
end
