require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/sign_in" do
    context '未ログインの場合' do
      it "リクエストが成功すること" do
        get  new_user_session_path
        expect(response).to have_http_status(200)
      end
    end

    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      it 'root_pathへリダイレクトすること' do
        sign_in user
        get  new_user_session_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET /users/sign_up" do
    context '未ログインの場合' do
      it "リクエストが成功すること" do
        get  new_user_registration_path
        expect(response).to have_http_status(200)
      end
    end

    context 'ログイン済みの場合' do
      let(:user) { create(:user) }
      it 'root_pathへリダイレクトすること' do
        sign_in user
        get  new_user_session_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET /users/edit" do
    let(:user) { create(:user) }

    context 'ログイン済みの場合' do
      it "リクエストが成功すること" do
        sign_in user
        get  edit_user_registration_path
        expect(response).to have_http_status(200)
      end
    end

    context '未ログインの場合' do
      it 'ログインページにリダイレクトされること' do
        get edit_user_registration_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST /users #create" do
    context "無効な値の時" do
      it "User登録がされないこと" do
        expect {
          post user_registration_path, params: { user: { name: '',
                                                        email: 'userexample.com',
                                                        password: 'foo',
                                                        password_confirmation: 'bar' } }
        }.to_not change(User, :count)
      end
    end

    context "有効な値の時" do
      let(:user_params) { { user: { name: 'Test User',
                                    email: 'user@example.com',
                                    password: 'password123',
                                    password_confirmation: 'password123' } } }

      it "User登録されること" do
        expect{
          post user_registration_path, params: user_params
        }.to change(User, :count).by (1)
      end

      it "rootへリダイレクトされること" do
        post user_registration_path, params: user_params
        expect(response).to redirect_to root_path
      end

      it 'ログイン状態であること' do
        post user_registration_path, params: user_params
        expect(signed_in?).to be_truthy
      end
    end
  end

  describe 'DELETE /users/sign_out ' do
    let(:user) { create(:user) }

    context 'ログイン済みの場合' do
      before do
        sign_in user
      end

      it 'ログアウトしたら、ログインページへリダイレクトすること' do
        delete destroy_user_session_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context '非ログインユーザの場合' do
      it 'ログインページへリダイレクトすること' do
        delete destroy_user_session_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH /users' do
    let(:user) { create(:user) }

    context 'ログイン済みユーザの場合' do
      before { sign_in user }

      context '無効な値の場合' do
        before do
          patch  user_registration_path, params: { user: { name: '',
                                                           email: '',
                                                           password: 'foo',
                                                           password_confirmation: 'bar',
                                                           current_password: 'password' } }
        end

        it '更新できないこと' do
          user.reload
          expect(user.name).to_not eq ''
          expect(user.email).to_not eq ''
          expect(user.password).to_not eq 'foo'
          expect(user.password_confirmation).to_not eq 'bar'
        end

        it '更新失敗後、editページが表示されていること' do
          expect(response.body).to include 'アカウント情報編集'
        end
      end

      context '有効な値の場合' do
        before do
          @name = 'Foo Bar'
          @email = 'foo@bar.com'
          @new_password = 'newpassword123'
          patch user_registration_path, params: { user: { name: @name,
                                                          email: @email,
                                                          password: @new_password,
                                                          password_confirmation: @new_password,
                                                          current_password: user.password } }
        end

        it '更新できること' do
          user.reload
          expect(user.name).to eq @name
          expect(user.email).to eq @email
          expect(user.valid_password?(@new_password)).to eq(true)
        end

        it 'アカウント編集ページにリダイレクトすること' do
          expect(response).to redirect_to edit_user_registration_path
        end
      end
    end

    context '非ログインユーザの場合' do
      it 'ログインページにリダイレクトされること' do
        patch user_registration_path, params: { user: { name: 'notloginuser',
                                                        email: 'notloginuser@example.com' } }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE /users/{id}' do
    let!(:user) { create(:user) }

    context '未ログインの場合' do
      it 'ログイン画面へリダイレクトすること' do
        delete user_registration_path
        expect(response).to redirect_to new_user_session_path
      end

      it '削除できないこと' do
        expect {
          delete user_registration_path
        }.to_not change(User, :count)
      end
    end

    context 'ログイン済みの場合' do
      it '削除できること' do
        sign_in user
        expect {
          delete user_registration_path
        }.to change(User, :count).by (-1)
      end
    end
  end
end
