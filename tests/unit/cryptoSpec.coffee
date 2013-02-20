

describe "UnobtrusivePasswords factories", ->

  describe "MyCrypto", ->

    beforeEach module 'UnobtrusivePasswords'

    it "should fail if not initialized", inject (MyCrypto)->
      expect(MyCrypto.getNext()).toBe("MyCrypto not initialized")

    it "should return the correct length substring", inject (MyCrypto)->
      MyCrypto.initialize("test","testkey")

      tmp = MyCrypto.getNext("testkey",4)
      expect(tmp.length).toBe(4)

      tmp = MyCrypto.getNext("testkey",8)
      expect(tmp.length).toBe(8)

    it "returns the expected hash", inject (MyCrypto)->

      MyCrypto.initialize "test", "testkey"

      tmp = MyCrypto.getNext "testkey",10
      expect(tmp).toBe "CUtDa9QBqh"
      tmp = MyCrypto.getNext "testkey",10
      expect(tmp).toBe "VUetfsi5y0"
      tmp = MyCrypto.getNext "testkey",10
      expect(tmp).toBe "wD8a1LAQec"
