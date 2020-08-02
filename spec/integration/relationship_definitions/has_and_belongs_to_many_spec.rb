# frozen_string_literal: true

RSpec.describe 'has_and_belongs_to_many associations' do
  let(:user)  { User.create!(name: 'Alice', uuid: SecureRandom.uuid) }
  let(:team)  { Team.create!(name: 'My Team', uuid: SecureRandom.uuid) }
  let(:teams) do
    (1..10).map { |i| Team.create!(name: "Team #{i}", uuid: SecureRandom.uuid) }
  end
  let(:users) do
    (1..10).map { |i| User.create!(name: "User #{i}", uuid: SecureRandom.uuid) }
  end

  describe 'writers' do
    it 'defines association_uuids= on left model' do
      user.team_uuids = teams.map(&:uuid)

      expect(user.teams.map(&:name)).to match_array(teams.map(&:name))
    end

    it 'defines association_uuids= on right model' do
      team.user_uuids = users.map(&:uuid)

      expect(team.users.map(&:name)).to match_array(users.map(&:name))
    end
  end

  describe 'readers' do
    before do
      user.update(team_ids: teams.map(&:id))
      team.update(user_ids: users.map(&:id))
    end

    it 'defines association_uuids on left model' do
      expect(user.team_uuids).to match_array(teams.map(&:uuid))
    end

    it 'defines association_uuids on right model' do
      expect(team.user_uuids).to match_array(users.map(&:uuid))
    end
  end
end
