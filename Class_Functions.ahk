; tbd
;  
IniReadIn(file, section, key, errorBypass = "")
{
  
  readVar := (IniRead(file, section, key, readVar)
  if !errorBypass
  {
    
  }
  if (readVar == "ERROR")
    Return
  
  if (!var)
  {
    Return readVar
  }
  else 
  {
    Return var
  }  
}
