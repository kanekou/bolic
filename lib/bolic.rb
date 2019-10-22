# coding: utf-8

require './bolic/parser'

class Bolic
  class ProgramError < StandardError; end
  
  def self.run(src)
    new(src).run
  end

  def initialize(src)
    @stmts = Parser.parse(src)
    @vars = {}
  end

  def run
    eval_stmts(@stmts)
  end

  private

  def eval(node)
    if node.is_a?(Integer)
      node
    else
      case node[0]
      when :+
        eval(node[1]) + eval(node[2])
      when :-
        eval(node[1]) - eval(node[2])
      when :*
        eval(node[1]) * eval(node[2])
      when :/
        eval(node[1]) / eval(node[2])
      when :char_out
        print eval(node[1]).chr
        nil
      when :num_out
        print eval(node[1])
        nil
      when :assign
        val = eval(node[1])
        @vars[tree[1]] = val
        val
      when :var
        val = @vars[node[1]]
        raise ProgramError, "初期化されていない変数を参照しました(#{tree[1]})" unless val
        val
      when :if
        if eval(tree[1]) != 0
          eval_stmts(tree[2])
        else
          if tree[3]
            eval_stmts(tree[3])
          else
            nil
          end
        end
      when :while
        while eval(tree[1]) != 0
          eval_stmts(tree[2])
        end
        nil
      else
        raise "命令の種類がわかりません(#{node[0]}.inspect)"
      end
    end
  end

  def eval_stmts(stmts)
    val = nil
    stmts.each do |node|
      val = eval(node)
    end
    val
  end
end

p Bolic.run(ARGF.read)
