{-# LANGUAGE OverloadedStrings #-}

import Data.List (sort)
import Data.Text (Text)
import qualified Data.Text as Text
import Lib ( sortArrayText )
import Test.QuickCheck ( withMaxSuccess, quickCheck )
import Test.QuickCheck.Instances ()

main :: IO ()
main = quickCheck (withMaxSuccess 10000 itSortsLines)

itSortsLines :: Int -> Bool -> Bool -> [Text] -> Bool
itSortsLines indentLevel leadBrace endBrace lns =
  -- We want each element of `lns` to represent a line, so by definition they
  -- shouldn't have newlines.
  let lnsWithoutNewlines = map (Text.filter (/= '\n')) lns
   in formatAsList indentLevel leadBrace endBrace (sort lnsWithoutNewlines)
        == sortArrayText (formatAsList indentLevel leadBrace endBrace lnsWithoutNewlines)

indent :: Int -> Text
indent n = Text.replicate n " "

formatAsList :: Int -> Bool -> Bool -> [Text] -> Text
formatAsList _ _ _ [] = ""
formatAsList indentLevel leadBrace endBrace (x : xs) =
  let elements =
        if leadBrace
            then ("[ " <> x) : map (", " <>) xs
            else map (", " <>) (x : xs)
      outLines =
        if endBrace
            then elements <> ["]"]
            else elements
      out = map (indent indentLevel <>) outLines
   in Text.unlines out