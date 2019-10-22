class Bolic
  class Parser
    class ParseError < StandardError;  end
     
   # 文字定める 
    VARIABLES = %w ( ⓧ  ⓨ  ⓘ  ⓙ  )
    NUMBERS = %w( ❶ ❷ ❸ ❹ ❺ ❻ ❼ ❽ ❾ ❿ )

    def self.parse(src)
      new(src).parse
    end

    def initialize(src)
      @tokens = trim_spaces(src).chars.to_a
      @cur = 0
    end
    
    # def run
    #   @stmts.each do |stmt|
    #     eval(stmt)
    #   end
    # end

    def parse
      parse_stmts
    end
  
    private

    def parse_output
      if match?("♨ ")
        [:char_out, parse_expr]
      elsif match?("✒")
        [:num_out, parse_expr]
      else
        parse_expr
      end
    end 
    
    # 読み込んだすべての式を保存した配列を返す
    def parse_stmts
      stmts = []
      while @cur < @tokens.size
        stmts << parse_stmt
      end
      stmts
    end
  
    def parse_stmt
      parse_output
    end
    
    def parse_expr
      parse_if
    end
  
    # TODO
    def parse_if
      if match?("🤔")
        cond = parse_expr
        raise ParseError " " unless match?(" ")
        thenc = parse_stmts(" " , " ")
        if match(" ") # thenの処理
          thenc = parse_stmts(" ") # else節のパース
          elsec = parse_stmts(" ") # then節のパース
        end
    end

    def parse_number
      c = @tokens[@cur]
      @cur += 1
      n = NUMBERS.index(c)
      raise ParseError, "数字でないものがきました(#{c})" unless n
      n
    end

    def parse_additive
      left = parse_multiple 
      if match?("➕")
        [:+, left, parse_expr]
      elsif match?("➖")
        [:-, left, parse_expr]
      else
        left
      end
    end
   
    def parse_multiple
      left = parse_variable
      if match?("✖")
        [:*, left, parse_multiple]
      elsif match?("➗")
        [:/, left, parse_multiple]
      else
        left
      end
    end

    def parse_variable
      c = @tokens[@cur]
      if VARIABLES.include?(c)
        @cur += 1
        if match("☚")
          [:assign, c, parse_expr]
        else
          [:var, c]
        end
      else 
        parse_number
      end
    end

    def parse_number
      c = @tokens[@cur]
      @cur += 1
      n = NUMBERS.index(c)
      raise ParseError, "数字でないものがきました(#{c})", unless n
      n
    end

    # 現在の文字がcかどうか判断
    def match?(c)
      if @tokens[@cur] == c
        @cur += 1
        true
      else
        false
      end
    end

    def trim_spaces(str)
      str.gsub(/\s/, "")
    end
  end
end

