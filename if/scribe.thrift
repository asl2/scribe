#!/usr/local/bin/thrift --cpp --php

##  Copyright (c) 2007-2008 Facebook
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.
##
## See accompanying file LICENSE or visit the Scribe site at:
## http://developers.facebook.com/scribe/

include "fb303/if/fb303.thrift"

namespace cpp scribe.thrift
namespace java scribe.thrift
namespace perl Scribe.Thrift

enum ResultCode
{
  OK,
  TRY_LATER,
  AUTHENTICATION_FAILED
}


struct LogEntry
{
  1:  string category,
  2:  string message
}


/*
 Currently scribe uses thrift TNonBlockingServer, which doesn't seem
to let the processor have access to per-client identity, and uses
a single global processor.  Thus, reauthenticate with each logging call.
Yes, this is wasteful.
*/

struct Authentication {
  1:  string user,
  2:  string password,
}

/* Use 255 tag for authentication to help avoid clashes with future
mainline developments, or other branches */
service scribe extends fb303.FacebookService
{
  ResultCode Log(1: list<LogEntry> messages, 255: Authentication credentials);
}

