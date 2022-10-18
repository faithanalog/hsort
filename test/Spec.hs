{-# LANGUAGE OverloadedStrings #-}

import Data.List (sort)
import Data.Text (Text)
import qualified Data.Text as Text
import Lib ( sortArrayText )
import Test.QuickCheck
import Test.QuickCheck.Instances ()

main :: IO ()
main = quickCheck (withMaxSuccess 10000 itSortsLines)

itSortsLines :: Int -> [Text] -> Bool
itSortsLines indentLevel lns =
  -- We want each element of `lns` to represent a line, so by definition they
  -- shouldn't have newlines.
  let lnsWithoutNewlines = map (Text.filter (/= '\n')) lns
   in formatAsList indentLevel (sort lnsWithoutNewlines) == sortArrayText (formatAsList indentLevel lnsWithoutNewlines)

indent :: Int -> Text
indent n = Text.replicate n " "

formatAsList :: Int -> [Text] -> Text
formatAsList _ [] = ""
formatAsList indentLevel (x : xs) =
  let indentation = indent indentLevel
      out =
        [indentation <> "[ " <> x]
          <> map (\ln -> indentation <> ", " <> ln) xs
          <> [indentation <> "]"]
   in Text.unlines out