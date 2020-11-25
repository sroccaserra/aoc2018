import Test.Hspec

main = hspec $ do
  describe "toto" $ do
    it "should pass" $ do
      6 `shouldBe` 6
