#### test/ebdic-koujien.rb -- unit test for ebdic module, using KOUJIEN

require 'test/ebdic-common'

class TestEBDicKoujien <TestEBDicCommon
  def setup
    super("/opt/epwing/koujien")
  end

  def test_search_not_found
    check([""], search("�ۤ�"))
    check([""], search("\001\001"))
    check([""], search("�����"))
  end

  def test_search
    check(["�����ȥޥ�", "��"], search("�����Ȥޤ�"))
    check(["��", "��"], search("����"))
    check(["����", "oui", "�ե��"], search("����"))
    check(["�ų����̥ȥ�󥸥�����"], search("�Ǥ󤫤��������Ȥ�󤸤�����"))
    check(["�Żҥ��ԥ���"], search("�Ǥ󤷤��Ԥ󤭤礦�ᤤ"))
    check(["�Żҥ᡼��"], search("�Ǥ󤷤᡼��"))
    check(["�פΰҤ�ڤ��"], search("�Ȥ�Τ��򤫤뤭�Ĥ�"))
    check(["�Ρ��٥��"], search("�Ρ��٤뤷�礦"))
    check(["Ǥ", "��", "����", "��", "��", "����", "��", "����", "�ޥ�", "maquis", "�ե��"],
	  search("�ޤ�"))
    check(["United States of America"],
	  search("��ʤ��Ƥäɤ��ơ��Ĥ��֤���꤫"))
    check(["�衼���å�", "Europa", "�ݥ�ȥ���", "������", "������"],
	  search("�衼���ä�"))
    check(["�亮��ȥ�", "Washington", "�亮��ȥ�", "Washington", "������"],
	  search("�路��Ȥ�"))
    check(["����", "�ۤ�"], search("�Ϥ���"))
  end

  def test_wildcard_not_found
    check([""], search("*"))
  end

  def test_wildcard
    check(["��", "�����θ�", "�פΰҤ�ڤ��"], search("*���Ĥ�"))
    check(["���Ϥ�ͧ"], search("�����Ф�*"))
  end
end

if __FILE__ == $0
  require 'test/unit/ui/console/testrunner'
  Test::Unit::UI::Console::TestRunner.run(TestEBDicKoujien.suite)
end

# test/ebdic-koujien.rb ends here