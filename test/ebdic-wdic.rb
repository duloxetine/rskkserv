### test/ebdic-wdic.rb -- unit test for ebdic module, using WDIC

require 'test/ebdic-common'

class TestEBDicWDic <TestEBDicCommon
  def setup
    super("/opt/epwing/wdic")
  end

  def test_format
    check(["�ۤ�"], format("�ۤ�", ["�ۤ�", "�ۤ� ���Ż�:����¯���"]))
  end

  def test_search_not_found
    check([""], search("���夲�स�夲��"))
    check([""], search("\001\001"))
  end

  def test_search
    check(["�Ϥˤ㡼��", "�Ϥˤ����"], search("�Ϥˤ㡼��"))
  end
end

if __FILE__ == $0
  require 'test/unit/ui/console/testrunner'
  Test::Unit::UI::Console::TestRunner.run(TestEBDicWDic.suite)
end

# test/ebdic-wdic.rb ends here
