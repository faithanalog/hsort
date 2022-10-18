{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( sortStdin,
    sortArrayText,
  )
where

import Data.List (sortBy)
import Data.Text (Text)
import qualified Data.Text as Text
import qualified Data.Text.IO as Text

sortStdin :: IO ()
sortStdin = do
  input <- Text.getContents
  Text.putStr (sortArrayText input)

sortArrayText :: Text -> Text
sortArrayText = Text.unlines . sortArrayElements . Text.lines

-- sort a haskelly array lexically, and correctly move the `[` on a first
-- element additionally, if one of the lines is a `]`, that should stay at the
-- end
sortArrayElements :: [Text] -> [Text]
sortArrayElements = withPreservedCloseBracket (rePrefixLines . sortBy compareLines)

withPreservedCloseBracket :: ([Text] -> [Text]) -> [Text] -> [Text]
withPreservedCloseBracket f [] = f []
withPreservedCloseBracket f lns =
  -- If the last line of lns is a close brace, don't apply the transformation to
  -- it. Make sure it stays there at the end
  case last lns of
    ln | Text.strip ln == "]" -> f (init lns) <> [ln]
    _ -> f lns

-- Compare lines by the text that comes AFTER the first [ or ,
-- this should be the actual array elements (maybe there's a leading) space but
-- its on all of them so it's fine.
compareLines :: Text -> Text -> Ordering
compareLines left right =
  let chopPrefix = Text.tail . Text.dropWhile (\c -> c /= '[' && c /= ',')
   in compare (chopPrefix left) (chopPrefix right)

-- Remove a line's current syntactic prefix ([ or ,) and put a new one where the
-- old one was
rePrefixLine :: Char -> Text -> Text
rePrefixLine newPrefix ln =
  case Text.findIndex (\c -> c == '[' || c == ',') ln of
    Nothing -> ln
    Just curPrefixIdx ->
      let (indents, element) = Text.splitAt curPrefixIdx ln
       in Text.concat [indents, Text.singleton newPrefix, Text.tail element]

-- If any of the lines have a `[` prefix, then we need to put a `[` on the
-- first element of the list and a `,` on the rest, because that means the
-- top of the list got included. If it's all commas, leave it like that.
rePrefixLines :: [Text] -> [Text]
rePrefixLines [] = []
rePrefixLines (ln : lns) =
  let -- Is the first non-space a square bracket?
      hasSquareBracketPrefix x = Text.head (Text.dropWhile (== ' ') x) == '['
   in if any hasSquareBracketPrefix (ln : lns)
        then rePrefixLine '[' ln : map (rePrefixLine ',') lns
        else ln : lns
