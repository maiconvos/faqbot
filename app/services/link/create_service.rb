module LinkModule
  class CreateService
    def initialize(params)
      # TODO: identify origin and set company
      @company = Company.last
      @url = params["url-original"]
      @hashtags = params["hashtags-original"]
    end

    def call
      return 'Hashtag Obrigatória' if @hashtags == nil || @hashtags == ""

      Link.transaction do
        link = Link.create(url: @url, company: @company)
        @hashtags.split(/[\s,]+/).each do |hashtag|
          link.hashtags << Hashtag.create(name: hashtag)
        end
      end
      "Link adicionado com sucesso"
    end
  end
end
