### test/ebdic-mypaedia.rb -- unit test for ebdic module, using MYPAEDIA

require 'test/ebdic-common'

class TestEBDicMypaedia <TestEBDicCommon
  def setup
    super("/opt/epwing/mypaedia", "MYPAEDIA")
  end

  def test_search
    check([""], search("�ۤ�"))
    check([""], search("\001\001"))

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

  def tear_down
  end
end

if __FILE__ == $0
  require 'runit/cui/testrunner'
  RUNIT::CUI::TestRunner.run(TestEBDicMypaedia.suite)
end

# test/ebdic-mypaedia.rb ends here
