
class A;
  extern static function void print(int a);
endclass

static function void A::print(int a);
  $display(" Data : %d",a);
endfunction


