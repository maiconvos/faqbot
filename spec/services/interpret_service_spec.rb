require_relative '../spec_helper.rb'

describe InterpretService do
  before :each do
    @company = create(:company)
  end

  describe '#list' do
    it "With zero faqs, return don't find message" do
      response = InterpretService.call('list', {})
      expect(response).to match("Nada encontrado")
    end

    it "With two faqs, find questions and answer in response" do
      faq1 = create(:faq, company: @company)
      faq2 = create(:faq, company: @company)

      response = InterpretService.call('list', {})

      expect(response).to match(faq1.question)
      expect(response).to match(faq1.answer)

      expect(response).to match(faq2.question)
      expect(response).to match(faq2.answer)
    end
  end

  describe '#search' do
    it "With empty query, return don't find message" do
      response = InterpretService.call('search', {"query": ''})
      expect(response).to match("Nada encontrado")
    end

    it "With valid query, find question and answer in response" do
      faq = create(:faq, company: @company)

      response = InterpretService.call('search', {"query" => faq.question.split(" ").sample})

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end

  describe '#search by category' do
    it "With invalid hashtag, return don't find message" do
      response = InterpretService.call('search_by_hashtag', {"query": ''})
      expect(response).to match("Nada encontrado")
    end

    it "With valid hashtag, find question and answer in response" do
      faq = create(:faq, company: @company)
      hashtag = create(:hashtag, company: @company)
      create(:faq_hashtag, faq: faq, hashtag: hashtag)

      response = InterpretService.call('search_by_hashtag', {"query" => hashtag.name})

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end

  describe '#create' do
    before do
      @question = FFaker::Lorem.sentence
      @answer = FFaker::Lorem.sentence
      @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
    end

    it "Without hashtag params, receive a error" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer})
      expect(response).to match("Hashtag Obrigatória")
    end

    it "With valid params, receive success message" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags})
      expect(response).to match("Criado com sucesso")
    end

    it "With valid params, find question and anwser in database" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags})
      expect(Faq.last.question).to match(@question)
      expect(Faq.last.answer).to match(@answer)
    end

    it "With valid params, hashtags are created" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags})
      expect(@hashtags.split(/[\s,]+/).first).to match(Hashtag.first.name)
      expect(@hashtags.split(/[\s,]+/).last).to match(Hashtag.last.name)
    end
  end

  describe '#remove' do
    it "With valid ID, remove Faq" do
      faq = create(:faq, company: @company)
      response = InterpretService.call('remove', {"id" => faq.id})
      expect(response).to match("Deletado com sucesso")
    end

    it "With invalid ID, receive error message" do
      response = InterpretService.call('remove', {"id" => rand(1..9999)})
      expect(response).to match("Questão inválida, verifique o Id")
    end
  end

  describe '#list_link' do
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
  end

  describe '#search_link' do
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
  end

  describe '#search_link_by_hashtag' do
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

  describe '#create_link' do
    before do
      @company = create(:company)
      @url = FFaker::Internet.domain_name
      @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
    end

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

  describe '#remove_link' do
    it "With valid ID, remove link" do
      link = create(:link, company: @company)
      @removeService = LinkModule::RemoveService.new({"id" => link.id})
      response = @removeService.call()

      expect(response).to match("Link removido com sucesso")
    end

    it "With invalid ID, receive error message" do
      @removeService = LinkModule::RemoveService.new({"id" => rand(1..9999)})
      response = @removeService.call()

      expect(response).to match("Id inválido")
    end

    it "With valid ID, remove link from database" do
      link = create(:link, company: @company)
      @removeService = LinkModule::RemoveService.new({"id" => link.id})

      expect(Link.all.count).to eq(1)
      response = @removeService.call()
      expect(Link.all.count).to eq(0)
    end
  end
end