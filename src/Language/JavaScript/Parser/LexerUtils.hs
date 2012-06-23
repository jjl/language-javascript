-----------------------------------------------------------------------------
-- |
-- Module      : Language.JavaScript.LexerUtils
-- Based on language-python version by Bernie Pope
-- Copyright   : (c) 2009 Bernie Pope
-- License     : BSD-style
-- Stability   : experimental
-- Portability : ghc
--
-- Various utilities to support the JavaScript lexer.
-----------------------------------------------------------------------------

module Language.JavaScript.Parser.LexerUtils (
  StartCode
  -- , AlexInput
  -- , alexGetChar
  -- , alexInputPrevChar
  , symbolToken
  , mkString
  , commentToken
  , wsToken
  , regExToken
  , decimalToken
  -- , endOfLine
  , endOfFileToken
  , assignToken
  , hexIntegerToken
  , octalToken
  , stringToken
  --, lexicalError
  ) where

--import Control.Monad.Error.Class (throwError)
import Language.JavaScript.Parser.Token as Token
import Language.JavaScript.Parser.SrcLocation
import Prelude hiding (span)

-- Functions for building tokens

type StartCode = Int

symbolToken :: Monad m => (TokenPosn -> [CommentAnnotation] -> Token) -> TokenPosn -> Int -> String -> m Token
symbolToken mkToken location _ _ = return (mkToken location [])

-- special tokens for the end of file and end of line
endOfFileToken :: Token
endOfFileToken = EOFToken tokenPosnEmpty []

mkString
  :: (Monad m) => (TokenPosn -> String -> Token) -> TokenPosn -> Int -> String -> m Token
mkString toToken loc len str = do return (toToken loc (take len str))

decimalToken :: TokenPosn -> String -> Token
decimalToken loc str = DecimalToken loc str []

hexIntegerToken :: TokenPosn -> String -> Token
hexIntegerToken loc str = HexIntegerToken loc str []

octalToken :: TokenPosn -> String -> Token
octalToken loc str = OctalToken loc str []

assignToken :: TokenPosn -> String -> Token
assignToken loc str = AssignToken loc str []

regExToken :: TokenPosn -> String -> Token
regExToken loc str = RegExToken loc str []

stringToken :: TokenPosn -> String -> Token
stringToken loc str = StringToken loc str1 delimiter []
  where
    str1 = init $ tail str
    -- str1 = stripLineContinuations $ init $ tail str
    delimiter = head str

commentToken :: TokenPosn -> String -> Token
commentToken loc str = CommentToken loc str []

wsToken :: TokenPosn -> String -> Token
wsToken loc str = WsToken loc str []

-- -----------------------------------------------------------------------------
-- Functionality required by Alex
{-
lexicalError :: P a
lexicalError = do
  location <- getLocation
  c <- liftM head getInput
  -- (_,c,_,_) <- getInput
  throwError $ UnexpectedChar c location
-}
-- EOF
