module LinkModule
  class ListService
    def initialize(params, action)
      # TODO: identify origin and set company
      @company = Company.last
      @action = action
      @query = params["query"]
    end

    def call
      if @action == "search_link"
        links = Link.search(@query).where(company: @company)
      elsif @action == "search_link_by_hashtag"
        links = []
        @company.links.each do |link|
          link.hashtags.each do |hashtag|
            links << link if hashtag.name == @query
          end
        end
      else
        links = @company.links
      end

      response = "*================ Links registrasdos ================* \n\n"
      links.each do |l|
        response += "*#{l.id}* - "
        response += "*#{l.url}*\n"
        l.hashtags.each do |h|
          response += " ##{h.name}"
        end
        response += "\n\n"
      end
      (links.count > 0)? response : "Nenhum link encontrado"
    end
  end
end
