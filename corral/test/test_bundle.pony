use "files"
use "ponytest"
use "../bundle"
use "../util"

class TestBundle is UnitTest
  fun name(): String => "bundle/bundle"

  fun apply(h: TestHelper) ? =>
    let log = Log(LvlNone, h.env.err, SimpleLogFormatter)

    h.assert_error(_BundleLoad(Data(h, "notfound!")?, log), "nonexistant directory")
    h.assert_error(_BundleLoad(Data(h, "empty-dir")?, log), "no bundle.json")
    h.assert_error(_BundleLoad(Data(h, "bad-json")?, log), "bad corral.json")

    h.assert_no_error(_BundleLoad(Data(h, "empty-file")?, log), "empty corral.json")
    h.assert_no_error(_BundleLoad(Data(h, "empty-deps")?, log), "empty deps")
    h.assert_no_error(_BundleLoad(Data(h, "github-leaf")?, log), "github dep")
    h.assert_no_error(_BundleLoad(Data(h, "local-git")?, log), "local-git dep")
    h.assert_no_error(_BundleLoad(Data(h, "local-direct")?, log), "local-direct dep")
    h.assert_no_error(_BundleLoad(Data(h, "abitofeverything")?, log), "mixed deps")

    // TODO: figure out useful tests for Bundle creation
    //h.assert_error(_BundleCreate("notfound"))?, log), "create in nonexistant directory")
    //h.assert_no_error(_BundleCreate(DataDir("empty")?, log), "create in directory with no bunde.json")

class _BundleLoad is ITest
  let path: FilePath
  let log: Log

  new create(path': FilePath, log': Log) =>
    path = path'
    log = log'

  fun apply() ? => Bundle.load(path, log)?

class _BundleCreate is ITest
  let path: FilePath
  let log: Log

  new create(path': FilePath, log': Log) =>
    path = path'
    log = log'

  fun apply() => Bundle.create(path, log)
