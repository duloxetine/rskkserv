### test/ebdic-mypaedia.rb -- unit test for ebdic module, using MYPAEDIA

require 'test/ebdic-common'

class TestEBDicMypaedia <TestEBDicCommon
  def setup
    super("/opt/epwing/mypaedia")
  end

  def test_search_not_found
    check([""], search("�ۤ�"))
    check([""], search("\001\001"))
  end

  def test_search
    check(["�����ȥޥ�"], search("�����Ȥޤ�"))
    check(["����"], search("���碌"))
    check(["���饹", "Maria Callas", "���饹", "��", "���ɽ�"],
	  search("���餹"))
    check(["�衼��å�", "Europe"], search("�衼��ä�"))
    check(["�ޥ�", "Maquis", "�ޥ�", "��", "��", "��"], search("�ޤ�"))
    check(["�Ρ��٥��"], search("�Ρ��٤뤷�礦"))
    check(["�", "�"], search("����"))
    check(["����", "����"], search("�ˤ���"))
    check(["������", "��Һ�"], search("������"))
  end
end

if __FILE__ == $0
  require 'test/unit/ui/console/testrunner'
  Test::Unit::UI::Console::TestRunner.run(TestEBDicMypaedia.suite)
end

# test/ebdic-mypaedia.rb ends here
