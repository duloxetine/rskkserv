# test/skkdic.rb -- unit test for skkdic module,
#		    using SKK-JISYO.L (v1.30 2000/12/07 12:11:23)

require "runit/testcase"
require "skkserv/skkdic.rb"

$jisyo = "/usr/share/skk/SKK-JISYO.L"
$cachedir = "/var/lib/rskkserv"
$nocache = nil

$stdout.sync = true

class SKKDicTest <RUNIT::TestCase
  def setup
    @skkdic = SKKDic.new($jisyo, $cachedir, $nocache)
  end

  def test_lookup_okuru_ari_failure
    assert(@skkdic.search("�ۤ�").empty?)
  end

  def test_lookup_okuri_ari_success
    assert_equal("��;��;��;��ĥ", @skkdic.search("���r").join(";"))
    assert_equal("��", @skkdic.search("��s").join(";"))
    assert_equal("��", @skkdic.search("��b").join(";"))
  end

  def test_lookup_okuru_nasi_failure
    assert(@skkdic.search("�ۤ�r").empty?)
  end

  def test_lookup_okuri_nasi_success
    assert_equal("��;��;��;��", @skkdic.search("����").join(";"))
    assert_equal("�������;�������;�����ʹ�",
		 @skkdic.search("��ޤ�������").join(";"))
    assert_equal("��;��ò��", @skkdic.search("!").join(";"))
    assert_equal("��", @skkdic.search("�ƥ�").join(";"))
  end

  def tear_down
  end
end

if __FILE__ == $0
  require "runit/cui/testrunner"
  RUNIT::CUI::TestRunner.run(SKKDicTest.suite)
end

# test/skkdic.rb ends here
