def _grep($v; filter_cond; string_cond; other_cond):
  if $v | type == "string" then
    ( ..
    | select(filter_cond and string_cond)
    )
  else
    ( ..
    | select(filter_cond and other_cond)
    )
  end;

def _value_grep_string_cond($v; $flags):
  if type == "string" then test($v; $flags)
  else false
  end;

def _value_grep_other_cond($v; $flags):
  . == $v;

def vgrep($v; $flags):
  _grep(
    $v;
    _is_scalar;
    _value_grep_string_cond($v; $flags);
    _value_grep_other_cond($v; $flags)
  );

def vgrep($v): vgrep($v; "");

def _buf_grep_any_cond($v; $flags):
  (isempty(tobytesrange | match($v; $flags)) | not)? // false;
def bgrep($v; $flags):
  _grep(
    $v;
    _is_scalar;
    _buf_grep_any_cond($v; $flags);
    _buf_grep_any_cond($v; $flags)
  );

def bgrep($v): bgrep($v; "");

def grep($v; $flags):
  _grep(
    $v;
    _is_scalar;
    _buf_grep_any_cond($v; $flags) or _value_grep_string_cond($v; $flags);
    _buf_grep_any_cond($v; $flags) or _value_grep_other_cond($v; $flags)
  );

def grep($v): grep($v; "");

def _field_grep_string_cond($v; $flags):
  (._name | test($v; $flags))? // false;

def fgrep($v; $flags):
  _grep(
    $v;
    _is_decode_value;
    _field_grep_string_cond($v; $flags);
    empty
  );

def fgrep($v): fgrep($v; "");
