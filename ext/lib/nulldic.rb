### skkserv/nulldic.rb --- rskkserv module for null dic.

## Copyright (C) 2005  YAMASHITA Junji

## Author:	YAMASHITA Junji <ysjj@unixuser.org>
## Version:	1.0

## This file is part of rskkserv.

## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License as
## published by the Free Software Foundation; either version 2, or (at
## your option) any later version.

## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.

### History:

## 2005/05/08:
# Created

### Code:

require "skkserv/logger"

class NULLDic
  def initialize()
  end

  def search(kana)
    []
  end

  def reload
  end

  def self.create(path, options, config)
    NULLDic.new()
  end
end

### skkserv/nulldic.rb ends here
