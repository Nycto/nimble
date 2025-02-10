# Copyright (C) Dominik Picheta. All rights reserved.
# BSD License. Look at license.txt for more info.

{.used.}

import unittest, os, strutils
import testscommon
from nimblepkg/common import cd

suite "path command":
  test "can get correct path for srcDir (#531)":
    cd "develop/srcdirtest":
      let (_, exitCode) = execNimbleYes("install")
      check exitCode == QuitSuccess
    let (output, _) = execNimble("path", "srcdirtest")
    let packageDir = getPackageDir(pkgsDir, "srcdirtest-1.0")
    check output.strip() == packageDir

  test "respects version constraint":
    cd "develop/srcdirtest":
      let (_, exitCode) = execNimbleYes("install")
      check exitCode == QuitSuccess
    check execNimble("path", "srcdirtest@1.0").exitCode == QuitSuccess
    check execNimble("path", "srcdirtest@2.0").exitCode != QuitSuccess

  test "can list paths for all dependencies":
    cd "path":
      check execNimbleYes("install").exitCode == QuitSuccess
      let (output, exitCode) = execNimble("path")
      checkpoint "nimble path output is " & output
      check exitCode == QuitSuccess
      check getPackageDir(pkgsDir, "timezones-0.5.4") in output
      check getPackageDir(pkgsDir, "htmlparser-0.1.0") in output
      check getPackageDir(pkgsDir, "sat-0.1.0") in output
