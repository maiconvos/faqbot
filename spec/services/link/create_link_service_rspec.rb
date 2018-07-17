require_relative './../../spec_helper.rb'

describe LinkModule::CreateService do
  before do
    @company = create(:company)
    @url = FFaker::Internet.domain_name
    @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
  end

  describe "#call" do
    it "Without hashtag params, will receive a error" do
      @createService = LinkModule::CreateService.new({"url-original" => @url})

      response = @createService.call()
      expect(response).to match("Hashtag Obrigatória")
    end

    it "With valid params, receive success message" do
      @createService = LinkModule::CreateService.new({"url-original" => @url, "hashtags-original" => @hashtags})

      response = @createService.call()
      expect(response).to match("Link adicionado com sucesso")
    end

    it "With valid params, find url in database" do
      @createService = LinkModule::CreateService.new({"url-original" => @url, "hashtags-original" => @hashtags})

      response = @createService.call()
      expect(Link.last.url).to match(@url)
    end

    it "With valid params, hashtags are created" do
      @createService = LinkModule::CreateService.new({"url-original" => @url, "hashtags-original" => @hashtags})

      response = @createService.call()
      expect(@hashtags.split(/[\s,]+/).first).to match(Hashtag.first.name)
      expect(@hashtags.split(/[\s,]+/).last).to match(Hashtag.last.name)
    end
  end
end
