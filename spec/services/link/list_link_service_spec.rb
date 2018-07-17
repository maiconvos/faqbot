require_relative './../../spec_helper.rb'

describe LinkModule::ListService do
  before do
    @company = create(:company)
  end

  describe '#call' do
    it "with list command: With zero links, return don't find message" do
      @listService = LinkModule::ListService.new({}, 'list_link')

      response = @listService.call()
      expect(response).to match("Nenhum link encontrado")
    end

    it "With two links, get urls" do
      @listService = LinkModule::ListService.new({}, 'list_link')

      link1 = create(:link, company: @company)
      link2 = create(:link, company: @company)

      response = @listService.call()

      expect(response).to match(link1.url)
      expect(response).to match(link2.url)
    end

    it "with search command: With empty query, return don't find message" do
      @listService = LinkModule::ListService.new({'query' => ''}, 'search_link')

      response = @listService.call()
      expect(response).to match("Nenhum link encontrado")
    end

    it "with search command: With valid query, find links" do
      link = create(:link, company: @company)

      @listService = LinkModule::ListService.new({'query' => link.url.split(" ").sample}, 'search_link')

      response = @listService.call()

      expect(response).to match(link.url)
    end

    it "with search_by_hashtag command: With invalid hashtag, return don't find message" do
      @listService = LinkModule::ListService.new({'query' => ''}, 'search_link_by_hashtag')

      response = @listService.call()
      expect(response).to match("Nenhum link encontrado")
    end

    it "with search_by_hashtag command: With valid hashtag, find links" do
      link = create(:link, company: @company)
      hashtag = create(:hashtag, company: @company)
      create(:link_hashtag, link: link, hashtag: hashtag)

      @listService = LinkModule::ListService.new({'query' => hashtag.name}, 'search_link_by_hashtag')

      response = @listService.call()

      expect(response).to match(link.url)
    end
  end
end
