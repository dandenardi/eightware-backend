require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) } # 🔴 Adicione esta linha

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  describe 'methods' do
    let(:user) { create(:user, first_name: 'John', last_name: 'Doe') }

    describe '#full_name' do
      it 'returns the full name' do
        expect(user.full_name).to eq('John Doe')
      end
    end

    describe '#jwt_payload' do
      it 'returns user data for JWT' do
        payload = user.jwt_payload.with_indifferent_access
        expect(payload["user_id"]).to eq(user.id)
        expect(payload["email"]).to eq(user.email)
      end
    end
  end

  describe 'JWT token generation' do
    let(:user) { create(:user) }

    it 'generates a unique JTI' do
      expect(user.jti).to be_present
      expect(user.jti).to be_a(String)
    end

    it 'generates different JTI for different users' do
      user2 = create(:user)
      expect(user.jti).not_to eq(user2.jti)
    end
  end
end
