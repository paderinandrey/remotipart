module Remotipart
  # Responder used to automagically wrap any non-xml replies in a text-area
  # as expected by iframe-transport.
  module RenderOverrides
if Rails.version < "5.0"
    include ERB::Util

    def self.included(base)
      base.class_eval do
        alias_method_chain :render, :remotipart
      end
    end
else
  prepend ERB::Util
end

    def render_with_remotipart *args
      render_without_remotipart *args
      if remotipart_submitted?
        textarea_body = response.content_type == 'text/html' ? html_escape(response.body) : response.body
        response.body = %{<script type=\"text/javascript\">try{window.parent.document;}catch(err){document.domain=document.domain;}</script>#{textarea_body}}
        response.content_type = Mime::HTML
      end
      response_body
    end
  end
end