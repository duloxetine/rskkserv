### skkserv/ebdic.rb --- rskkserv module for EB dictionary.

## Copyright (C) 2000,2001  YAMASHITA Junji

## Author:	YAMASHITA Junji <ysjj@unixuser.org>
## Version:	1.1

## This file is part of rskkserv.

## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License as
## published by the Free Software Foundation; either version 2, or (at
## your option) any later version.

## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.

### Code:

begin
  require "eb"
rescue LoadError
  Logger::log(Logger::INFO, "failed to load eb")
end

require "skkserv/logger"

# ddskk/skk-vars.el �� skk-lookup-option-alist �ѿ��򻲹ͤˤ�����
module EPWAgent
  GAIJI = "<?>"

  def gaiji_nasi?(str)
    str.index(GAIJI).nil?
  end

  def subbook(book, subbook_)
    if subbook_
      subbook = subbook_.upcase
      unless self.support_subbook.include?(subbook)
        raise "#{self}: #{subbook_}: unsupported subbook"
      end
    else
      subbook = self.default_subbook
    end

    book.subbook_list.each do |n|
      return n if book.directory(n).upcase == subbook
    end

    raise "#{subbook}: subbook not found"
  end

  def support_subbook
    [default_subbook]
  end

  module_function
  def find(book)
    agents = constants.map {|m| const_get(m)}.select {|m| m.respond_to?(:support_subbook)};

    book.subbook_list.map {|n| book.directory(n).upcase}.each do |subbook|
      agents.each do |m|
        return m if m.support_subbook.include?(subbook)
      end
    end

    return nil
  end

  # ����:
  # "������"
  #   => "���Ф�"
  #   => "�Ѵ�����1", "�Ѵ�����2", ...

  # KOUJIEN: ������ �����
  # �����»���
  # (1) ������ޤ�ñ����Ѵ�����˴ޤ�ʤ���
  # (2) ���겾̾�ˤ��б����Ƥ��ʤ���
  module KOUJIEN
    extend EPWAgent

    # ��:
    # "�����Ȥޤ�"
    #	=> "�����ȥޥ��<?>tman ���"
    #	=> "�����ȥޥ�", "��"
    # "����"
    #	=> �������ġۥ���", "�����ڲ��ۥ���"
    #	=> "��", "��"
    # "����"
    #	=> "������oui �ե�󥹡�"
    #	=> "����", "oui", "�ե��"
    # "�Ǥ󤫤��������Ȥ�󤸤�����"
    #   => "�Ǥ󤫤������������ȥ�󥸥��������ų����̡���"
    #   => "�ų����̥ȥ�󥸥�����"
    # "�Ǥ󤷤��Ԥ󤭤礦�ᤤ"
    #   => "�Ǥ󤷡����ԥ󡾤��礦�ᤤ���Żҡ����ġ�"
    #   => "�Żҥ��ԥ���"
    # "�Ǥ󤷤᡼��"
    #   => "�Ǥ󤷡��᡼����Żҡ���"
    #   => "�Żҥ᡼��"
    # "�Ȥ�Τ��򤫤뤭�Ĥ�"
    #   => "���פΰҤ�ڤ��"
    #   => "�פΰҤ�ڤ��"
    # "�Ρ��٤뤷�礦"
    #	=> "�Ρ��٥롾���礦�ڡ��ޡۡť��䥦"
    #	=> "�Ρ��٥��"
    # "�Ϥ���"
    #   => "�Ϥ���������롦�ۤ��"
    #   => "����", "�ۤ�"
    # "�Ӥ��ߤ�"
    #   => "�ӥ��ߥ��Vitamin �ɥ��ġ�vitamine �����ꥹ��"
    #   => "�ӥ��ߥ�", "Vitamin", "�ɥ���", "vitamine", "�����ꥹ",
    # "�����"
    #   => "����ꡡ���ϥ�"
    #   =>
    # "��ʤ��Ƥäɤ��ơ��Ĥ��֤���꤫"
    #	=> "��ʥ��ƥåɡ����ơ��ġ����֡�����ꥫ��United States of America��"
    #	=> "United States of America"
    # "�衼��ä�"
    #	=> "�衼��åѡ�Europa �ݥ�ȥ��롦�������������á�"
    #	=> "�衼��å�", "Europa", "�ݥ�ȥ���", "������", "������"
    # "�路��Ȥ�"
    #	=> "�亮��ȥ��Washington��", "�亮��ȥ��Washington�������ܡ�"
    #	=> "�亮��ȥ�", Washington", "�亮��ȥ�", "Washington", "������"
    MATCH_REGEXP = /\A��?([^����]+)(��([^��]+)��)?/e
    WORD_LANG_REGEXP = /([ .0-9<=>?A-Za-z]+) ([����-����]+)/e

    MIDPOINT_EUCJP = "\xa1\xa6" # "��"
    DASH_EUCJP = "\xa1\xbd"	# "��"
    HYPHEN_EUCJP = "\xa1\xbe"	# "��"
    
    STEM_DELIMITER_EUCJP = MIDPOINT_EUCJP
    WORD_DELIMITER_EUCJP = HYPHEN_EUCJP
    SUBST_CHAR_EUCJP = DASH_EUCJP

    module_function
    def format(kana, candidates)
      result = []

      candidates.each do |e|
	MATCH_REGEXP =~ e

	g1,g2 = $1,$3

	g1.gsub!(STEM_DELIMITER_EUCJP, "")
	words = g1.split(WORD_DELIMITER_EUCJP)

	if words.length == 1 and g1 != kana and gaiji_nasi?(g1)
	  result.push(g1)
	end

	if g2
	  g2.split(MIDPOINT_EUCJP).each do |e|
	    format_sub(result, words, e)
	  end
	end
      end

      result
    end

    def format_sub(result, substs, candidate)
      WORD_LANG_REGEXP =~ candidate

      if $1
	result.push($1) if gaiji_nasi?($1)
	word = $2
      else
	word = candidate
      end

      return unless gaiji_nasi?(word)

      word.sub!(SUBST_CHAR_EUCJP) do
	if $`.empty?
	  substs[0]
	elsif substs[2] and $'.empty?
	  substs[2]
	else
	  substs[1]
	end
      end

      result.push(word)
    end

    def support_subbook
      [default_subbook, "KOJIEN"]
    end

    def default_subbook
      "KOUJIEN"
    end
  end

  # MYPAEDIA-fpw
  module MYPAEDIA
    extend EPWAgent

    # ��:
    # "�����Ȥޤ�"
    #	=> "�����ȥޥ� (<?>tman)"
    #	=> "�����ȥޥ�"
    # "���碌"
    #	=> "���� [���碌] (��)"
    #	=> "����"
    # "���餹"
    #	=> "���饹 (Maria Callas)",
    #	   "���饹 (��) [���饹]",
    #	   "���ɽ� [���餹] (Į)"
    #	=> "���饹", "Maria Callas", "���饹", "��", "���ɽ�"
    # "����"
    #   => "���� (�/�) [����]"
    #   => "�", "�"
    # "�ˤ���"
    #   => "����/���� [�ˤ���]"
    #   => "����", "����"
    # "�Ρ��٤뤷�礦"
    #	=> "�Ρ��٥�� [�Ρ��٥뤷�礦]"
    #	=> "�Ρ��٥��"
    # "�衼��ä�"
    #	=> "�衼��å� (Europe)"
    #	=> "�衼��å�", "Europe"
    # "������"
    #  => "���� (���) �� [������]"
    #  => "������", "��Һ�"
    MATCH_REGEXP = /\A([^ ]+)( +\(([^\)]+)\) *([^ ]+)?)?/

    module_function
    def format(kana, candidates)
      result = []

      candidates.each do |e|
	e.sub!(/\[.+$/, "")
	MATCH_REGEXP =~ e
	r = []
	format_sub(r, $1) if $1 != kana
	format_sub(r, $3) if $3
	r.each {|s| s << $4} if $4
	result.concat(r)
      end

      result
    end

    def format_sub(result, candidate)
      candidate.split("/").each do |v|
	result.push(v) if gaiji_nasi?(v)
      end
    end

    def default_subbook
      "MYPAEDIA"
    end
  end

  module WDIC
    extend EPWAgent

    module_function
    def format(kana, candidates)
      candidates
    end

    def default_subbook
      "WDIC"
    end
  end
end

class EBDic
  def initialize(path, mod = nil, subbook = nil)
    @book = new_book(path)
    @formatter = get_formatter(mod)

    @book.subbook = @formatter.subbook(@book, subbook)
  end

  def search(kana)
#    Logger::log(Logger::DEBUG, "search: \"%s\", book: %s", kana, @book)
    begin
      candidates = if kana[-1] == ?* and @book.search_available?
		     kana2 = kana[0..-2]
		     @book.search2(kana2)
		   elsif kana[0] == ?* and @book.endsearch_available?
		     kana2 = kana[1..-1]
		     @book.endsearch2(kana2)
		   else
		     kana2 = kana
		     @book.exactsearch2(kana)
		   end
      result = @formatter.format(kana2, candidates.collect {|a| a[1]})
    rescue RuntimeError
      raise if $!.to_s != "fail searching"
      result = []
    end

#    Logger::log(Logger::DEBUG, "candidates: \"%s\"", result.join(","))
    result
  end

  def to_s
    format('#<EBDic: path="%s", directory="%s", title="%s">',
	   @book.path, @book.directory, @book.title)
  end

  def self.create(path, options, config)
    return EBDic.new(path, options["module"], options["subbook"])
  end

  private
  def new_book(path)
    result = EB::Book.new

    begin
      result.bind(path)
    rescue RuntimeError
      raise "#{path}: book not found"
    end

    result
  end

  def get_formatter(mod)
    unless mod
      result = EPWAgent.find(@book)
      raise "#{@book.path}: Not found module for" unless result
      return result
    end

    m = mod.upcase
    raise "#{mod}: Unknown module" unless EPWAgent.constants.include?(m)
    return EPWAgent.const_get(m)
  end
end

if __FILE__ == $0
  print EBDic.new("/opt/epwing/koujien", "KOUJIEN").search("����").join("/"), "\n"
end

### skkserv/ebdic.rb ends here
