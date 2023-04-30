require "rails_helper"

RSpec.describe "Docs", type: :request do
  let(:username) { ENV["ADMIN_USERNAME"] }
  let(:password) { ENV["ADMIN_PASSWORD"] }

  before do
    Rails.application.credentials.basic_auth = {
      username: username,
      password: password
    }
  end

  describe "#index" do
    context "with valid credentials" do
      it "renders the index template" do
        get docs_path, headers: {"Authorization" => "Basic #{Base64.encode64("#{username}:#{password}")}"}
        expect(response).to have_http_status(200)
      end
    end

    context "with invalid credentials" do
      it "returns a 401 Unauthorized status" do
        get docs_path, headers: {"Authorization" => "Basic #{Base64.encode64("wrong_username:wrong_password")}"}
        expect(response).to have_http_status(401)
      end
    end

    context "without credentials" do
      it "returns a 401 Unauthorized status" do
        get docs_path
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "#new" do
    context "with valid credentials" do
      it "renders the new template" do
        get new_doc_path, headers: {"Authorization" => "Basic #{Base64.encode64("#{username}:#{password}")}"}
        expect(response).to have_http_status(200)
      end
    end

    context "with invalid credentials" do
      it "returns a 401 Unauthorized status" do
        get new_doc_path, headers: {"Authorization" => "Basic #{Base64.encode64("wrong_username:wrong_password")}"}
        expect(response).to have_http_status(401)
      end
    end

    context "without credentials" do
      it "returns a 401 Unauthorized status" do
        get new_doc_path
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "#show" do
    let(:doc) { create(:doc) }

    it "shows the page, regardless of the credentials" do
      get doc_path(doc.slug)
      expect(response).to have_http_status(200)
    end
  end

  describe "#create" do
    context "with valid attributes" do
      let(:valid_attributes) { attributes_for(:doc) }

      it "creates a new Doc" do
        expect {
          post docs_path, params: {doc: valid_attributes}, headers: {"Authorization" => "Basic #{Base64.encode64("#{username}:#{password}")}"}
        }.to change(Doc, :count).by(1)
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { attributes_for(:doc, title: "", content: "") }

      it "does not create a new Doc" do
        expect {
          post docs_path, params: {doc: invalid_attributes}, headers: {"Authorization" => "Basic #{Base64.encode64("#{username}:#{password}")}"}
        }.not_to change(Doc, :count)
      end
    end

    xcontext "with a password" do
      let(:doc_with_password) { attributes_for(:doc, :with_password) }

      it "creates a new Doc with a password" do
        post docs_path, params: {doc: doc_with_password}, headers: {"Authorization" => "Basic #{Base64.encode64("#{username}:#{password}")}"}
        expect(Doc.last.password_digest).not_to be_nil
      end
    end

    xcontext "without a password" do
      let(:doc_without_password) { attributes_for(:doc, :without_password) }

      it "creates a new Doc without a password" do
        post docs_path, params: {doc: doc_without_password}, headers: {"Authorization" => "Basic #{Base64.encode64("#{username}:#{password}")}"}
        expect(Doc.last.password_digest).to be_nil
      end
    end
  end

  describe "#edit" do
    let(:doc) { create(:doc) }

    context "with valid credentials" do
      it "renders the edit template" do
        get edit_doc_path(doc.slug), headers: {"Authorization" => "Basic #{Base64.encode64("#{username}:#{password}")}"}
        expect(response).to have_http_status(200)
      end
    end

    context "with invalid credentials" do
      it "returns a 401 Unauthorized status" do
        get edit_doc_path(doc.slug), headers: {"Authorization" => "Basic #{Base64.encode64("wrong_username:wrong_password")}"}
        expect(response).to have_http_status(401)
      end
    end

    context "without credentials" do
      it "returns a 401 Unauthorized status" do
        get edit_doc_path(doc.slug)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "#update" do
    let!(:doc) { create(:doc) }
    let(:valid_attributes) { {title: "SUPER LAVA FIRE", content: "Update me to blahblahblah"} }
    let(:invalid_attributes) { {title: "", content: ""} }

    context "with valid attributes" do
      it "updates the Doc and redirects to the show page" do
        put doc_path(doc.slug), params: {doc: valid_attributes}, headers: {"Authorization" => "Basic #{Base64.encode64("#{username}:#{password}")}"}
        doc.reload
        expect(doc.title).to eq("SUPER LAVA FIRE")
        expect(doc.content).to eq("Update me to blahblahblah")
      end
    end

    context "with invalid attributes" do
      it "does not update the Doc and renders the edit template" do
        put doc_path(doc.slug), params: {doc: invalid_attributes}, headers: {"Authorization" => "Basic #{Base64.encode64("#{username}:#{password}")}"}
        expect(doc.reload.title).not_to eq("")
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:doc) { create(:doc) }

    it "destroys the Doc and redirects to the index page" do
      expect {
        delete doc_path(doc.slug), headers: {"Authorization" => "Basic #{Base64.encode64("#{username}:#{password}")}"}
      }.to change(Doc, :count).by(-1)
      expect(response).to redirect_to(docs_path)
    end
  end
end
