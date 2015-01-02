Summary: SKK Dictionary server for Ruby
Name: rskkserv
Version: 2.95.5
Release: 2
License: GPL
Group: Applications/System
Source: %{name}-%{version}.tar.bz2
URL: http://www.unixuser.org/~ysjj/rskkserv/
BuildRoot: %{_tmppath}/%{name}-%{version}-buildroot
BuildRequires: ruby >= 1.6, ruby-devel >= 1.6
PreReq: chkconfig
Provides: skkserv
Obsoletes: skkserv, dbskkd-cdb

%description
rskkserv is an alternate version of skkserv for Ruby.

%prep
%setup -q
[ "$RPM_BUILD_ROOT" != "/" ] && rm -fr $RPM_BUILD_ROOT
%patch0 -p1 -b .mk


%build
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
	--with-rubylibdir=/usr/lib/ruby/1.8
make RPM_OPT_FLAGS="${RPM_OPT_FLAGS}"


%install
make DESTDIR=$RPM_BUILD_ROOT install

find $RPM_BUILD_ROOT -type f -print | sed "s^$RPM_BUILD_ROOT^^" > rskkserv-flst
find $RPM_BUILD_ROOT -type d -printf "%%%%dir %%p\n" | \
	sed "s^$RPM_BUILD_ROOT^^" >> rskkserv-flst


%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -fr $RPM_BUILD_ROOT


%files -f rskkserv-flst
%defattr(-, root, root)


%changelog
* Tue Nov 13 2001 Satoru SATOH <ssato@redhat.com> - 2.94.12-2
- fix: the libraries of rskkserv are not installed

* Wed Oct 17 2001 Satoru SATOH <ssato@redhat.com> - 2.94.12-1
- Initial release
