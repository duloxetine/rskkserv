# test/cdbdic.rb -- unit test for cdbdic module,
#		    using SKK-JISYO.L.cdb (skkdic-cdb 20040323-1 deb)

require "skkserv/cdbdic.rb"
require "test/unit/testcase"

$jisyo = "/usr/share/skk/SKK-JISYO.L.cdb"

$stdout.sync = true

class TestCDBDic <Test::Unit::TestCase
  def setup
    @skkdic = CDBDic.new($jisyo)
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
    assert_equal("��,��,��", @skkdic.search("����").join(","))
    assert_equal("�������,�����ʹ�;�������",
		 @skkdic.search("��ޤ�������").join(","))
    assert_equal("��,��ò��", @skkdic.search("!").join(","))
  end

  def tear_down
  end
end

if __FILE__ == $0
  require "test/unit/ui/console/testrunner"
  Test::Unit::UI::Console::TestRunner.run(TestCDBDic.suite)
end

# test/cdbdic.rb ends here
