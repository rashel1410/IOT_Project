import http.client
import json
import urllib.parse
import ssl

def search_food_item_with_http_client(food_name):
    """
    Searches for a food item using the USDA FoodData Central API with http.client.

    Parameters:
        food_name (str): The name of the food item to search.
        api_key (str): Your USDA FoodData Central API key.

    Returns:
        dict: The search results from the API.
    """
    api_key = "jKaj2JaaLo0FJuIqO1D150ppUCv2HbIcXUdYWCtL"
    # conn = http.client.HTTPSConnection("api.nal.usda.gov")
    conn = http.client.HTTPSConnection("api.nal.usda.gov", context=ssl._create_unverified_context())
    # URL encode the query parameters
    params = urllib.parse.urlencode({
        "query": food_name,
        "pageSize": 1,
        "api_key": api_key
    })

    # Define the endpoint with encoded parameters
    endpoint = f"/fdc/v1/foods/search?{params}"

    try:
        # Make the GET request
        conn.request("GET", endpoint)
        response = conn.getresponse()
        
        # Read and decode the response
        data = response.read().decode("utf-8")
        
        # Close the connection
        conn.close()
        
        # Parse and return the JSON response
        return json.loads(data)
    except Exception as e:
        print(f"Error: {e}")
        conn.close()
        return None


            
