# frozen_string_literal: true

module StimulusReflex
  module HTML
    class Document
      DEFAULT_HTML_WITHOUT_FORMAT = Nokogiri::XML::Node::SaveOptions::DEFAULT_HTML & ~Nokogiri::XML::Node::SaveOptions::FORMAT

      delegate :element, to: :@document

      def document_element
        @document&.root
      end

      def outer_html
        document_element ? document_element.to_html(save_with: DEFAULT_HTML_WITHOUT_FORMAT) : ""
      end
      alias_method :to_html, :outer_html

      def inner_html
        document_element ? document_element.inner_html(save_with: DEFAULT_HTML_WITHOUT_FORMAT) : ""
      end

      def initialize(html)
        @document = parse_html(html)
        @matches = {
          "body" => Match.new(@document.at_css("body"))
        }
      end

      def parse_html(html)
        Nokogiri::HTML5::Document.parse(html.to_s)
      end

      def empty?
        @document.content.empty?
      end

      def match(selector)
        @matches[selector] ||= Match.new(@document.at_css(selector))
      end

      Match = Struct.new(:element) do
        delegate :present?, to: :element

        def outer_html
          element&.to_html(save_with: DEFAULT_HTML_WITHOUT_FORMAT)
        end

        def to_html
          element&.to_html(save_with: DEFAULT_HTML_WITHOUT_FORMAT)
        end

        def inner_html
          element&.inner_html(save_with: DEFAULT_HTML_WITHOUT_FORMAT)
        end
      end
    end
  end
end
