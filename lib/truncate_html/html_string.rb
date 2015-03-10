# encoding: utf-8
module TruncateHtml
  class HtmlString < String

    UNPAIRED_TAGS = %w(br hr img).freeze
    REGEX = /(?:<script.*>.*<\/script>)+|<\/?[^>]+>|[[[:alpha:]][\u{1F300}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{2600}-\u{27BF}
            \u{1F1E6}-\u{1F1FF}\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u2614\u2615\u2648-\u2653\u267F\u2693
            \u26A1\u26AA\u26AB\u26B3-\u26BD\u26BF-\u26E1\u26E3-\u26FF\u2705\u270A\u270B\u2728\u274C\u274E
            \u2753\u2757\u2795\u2796\u2797\u27B0\u27BF\u{1F1E6}-\u{1F1FF}][0-9]\|`~!@#\$%^&*\(\)\-_\+=\[\]{}:;'²³§",\.\/?]+|\s+|[[:punct:]]/.freeze

    def initialize(original_html)
      super(original_html)
    end

    def html_tokens
      scan(REGEX).map do |token|
        HtmlString.new(
          token.gsub(
            /\n/,' ' #replace newline characters with a whitespace
          ).gsub(
            /\s+/, ' ' #clean out extra consecutive whitespace
          )
        )
      end
    end

    def html_tag?
      /<\/?[^>]+>/ === self && !html_comment?
    end

    def open_tag?
      /<(?!(?:#{UNPAIRED_TAGS.join('|')}|script|\/))[^>]+>/i === self
    end

    def html_comment?
      /<\s?!--.*-->/ === self
    end

    def matching_close_tag
      gsub(/<(\w+)\s?.*>/, '</\1>').strip
    end

  end
end
