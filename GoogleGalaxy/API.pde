//Getting the google images results in JSON format

String[] img_urls(int fours)
{
  String[] url = new String[fours];
  String[] links = new String[4*fours];
   
  for(int t=0; t<fours; t++)
      {        
        
        //replace the spacebar with %20, which is how its written in google URLs
        searchTerm = searchTerm.replaceAll(" ", "%20");
        
        url[t] = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q="+searchTerm+ "&start="+(t*4);
        
        // find more search arguments here
        // https://developers.google.com/image-search/v1/jsondevguide#json_args
        
        response = loadJSONObject(url[t]);
        response = response.getJSONObject("responseData");
        results = response.getJSONArray("results");

        for (int i = 0; i < results.size(); i++) {
    
          JSONObject result = results.getJSONObject(i); 

          high[(i+(4*t))] = result.getInt("height");
          wide[(i+(4*t))] = result.getInt("width");
          String linkstring = result.getString("unescapedUrl");      
          links[(i+(4*t))] = linkstring;
          
          //println("Photo has height " + high + " and width " + wide + " is at ");
          //println(linkstring);        
        } 
      }
     return links;
}
