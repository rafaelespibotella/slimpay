require 'spec_helper'

RSpec.describe Slimpay do
  it 'has a version number' do
    expect(Slimpay::VERSION).not_to be nil
  end

  it 'answers to nil HTTP responses' do
    expect(Slimpay.answer(nil)).not_to be nil
  end

  it 'defines API constants' do
    expect(Slimpay::PRODUCTION_ENDPOINT).not_to be nil
    expect(Slimpay::PRODUCTION_ENDPOINT).to eq 'https://api.slimpay.com'
    expect(Slimpay::SANDBOX_ENDPOINT).not_to be nil
    expect(Slimpay::SANDBOX_ENDPOINT).to eq 'https://api.preprod.slimpay.com'
  end

  describe '.configure' do
    before do
      Slimpay.configure do |config|
        config.client_id = 'testcreditor01'
        config.client_secret = 'testsecret01'
        config.creditor_reference = 'testcreditor'
        config.return_url = 'localhost:3000'
        config.notify_url = 'localhost:3000'
        config.username = 'admin@test.com'
        config.password = '123456'
      end
    end

    it 'initializes the variables with given config' do
      expect(Slimpay.configuration.client_id).to eq('testcreditor01')
      expect(Slimpay.configuration.client_secret).to eq('testsecret01')
      expect(Slimpay.configuration.creditor_reference).to eq('testcreditor')
      expect(Slimpay.configuration.return_url).to eq('localhost:3000')
      expect(Slimpay.configuration.notify_url).to eq('localhost:3000')
      expect(Slimpay.configuration.username).to eq('admin@test.com')
      expect(Slimpay.configuration.password).to eq('123456')
    end
  end

  describe '.answer' do
    let(:http_response) {double('HTTParty::Response')}
    let(:response_body) {'response_body'}

    it 'fails on HTTP code >= 400' do
      expect(http_response).to receive(:code) {400}
      expect(Slimpay::Error).to receive(:new).with(http_response)
      Slimpay.answer(http_response)
    end

    it 'returns the response as is if HTTP code < 400' do
      expect(http_response).to receive(:code) {200}
      expect(http_response).to receive(:body) {response_body}

      expect(Slimpay::Error).not_to receive(:new).with(http_response)
      expect(Slimpay.answer(http_response)).to eq(response_body)
    end
  end
end
