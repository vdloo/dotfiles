<?php
/*
the instagram API allows to either search for images based on a user OR by hashtags,
this script enables you to filter images from a certain user based on one or more hashtags

Example:

$token 		= 'your token'; 	// http://jelled.com/instagram/access-token
$userid 	= 'your userid'; 	// http://jelled.com/instagram/lookup-user-id

$hashtags	= array(
	'frontpage' 	=> ['globaltag'],
	'sub1'		=> ['globaltag', 'subtag'],
);

populate instagram image array
$instagram_sorted 	= instagram_by_hashtags_and_userid($token, $userid, $hashtags);

prints all image urls for the hashtags 'globaltag' and 'subtag';
foreach($instagram_sorted['sub1']['items'] as $post_obj) {
	$imgurl 	= $post_obj->images->standard_resolution->url;
	echo "image url: $imgurl\n";
}
*/


// get response from url
function curl_text($url) 
{
	$curl_handle = curl_init();
	$to = 20;
	curl_setopt($curl_handle, CURLOPT_URL, $url);
	curl_setopt($curl_handle, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($curl_handle, CURLOPT_CONNECTTIMEOUT, $to);
	$data = curl_exec($curl_handle);
	if ($data === FALSE) die(curl_error($curl_handle));
	curl_close($curl_handle);
	return $data;
}

// turn api text response into data array
function text2instadat($response)
{
	$instaobj = json_decode($response);
	if (!property_exists($instaobj, 'data')) die ("Failed to get valid data from Instagram API");
	$instadat = $instaobj->data;
	return $instadat;
}

function forge_api_url($token, $userid)
{
	return "https://api.instagram.com/v1/users/".$userid."/media/recent?access_token=".$token;
}

// returns array with items that are tagged with all hashtags in $tags array
function find_tagged($instadat, $tags2check)
{
	$result = Array();
	// loop through all posted images
	foreach ($instadat as $item) {
		$tags = $item->tags;
		$tagcount = 0;
		// loop through all words the image is tagged with
		foreach ($tags as $tag) {
			// increase tagcount if hashtag is in $tags array
			if (in_array($tag, $tags2check)) {
				$tagcount++;
			}
		}
		// add image to $result array if all hashtags in the $tags array were found
		$tags2checkcount = count($tags2check);
		if ($tags2checkcount > 0 && $tagcount == $tags2checkcount) {
			$keyuuid 	= crc32($item->images->standard_resolution->url); // hash with crc32 so keys stay consistent 
			$result[$keyuuid] = $item;
		}
	}
	return $result;
}

// curl Instagram api and return data array
function data_from_instagram_api($token, $userid)
{
	$api_url 	= forge_api_url($token, $userid);
	$response 	= curl_text($api_url);
	$instadat	= text2instadat($response);
	return $instadat;
}

// returns data object from cache or Instagram API if cache doesn't exist or is too old.
function cached_insta_response($token, $userid) 
{
	$instadat 	= 'failed';
	$apicache 	= 'cache/insta_API.json';
	// check if cache exists and if cache was created less than an hour ago
	if (file_exists($apicache) && ((time() - filemtime($apicache)) < 60 * 60)) { 
		//echo 'using cache';
		$instadat = json_decode(file_get_contents($apicache));
	} else {
		//echo 'calling api';
		$instadat 	= data_from_instagram_api($token, $userid);
		file_put_contents($apicache, json_encode($instadat));
	}
	return $instadat;
}

// return object containing posted Instagram posts by userid filtered based on hashtags
function insta_img_array($insta_img, $token, $userid, $hashtags) 
{
	$instadat = cached_insta_response($token, $userid);
	if ($instadat == 'failed') die("failed to get the Instagram data array");

	foreach($hashtags as $tagskey => $tags2check) {
		$insta_img[$tagskey] = array(
			'tagsarray' 	=> $tags2check,
			'items'		=> find_tagged($instadat, $tags2check),	
		);
	}
	return $insta_img;
}

// loads Instagram image array into variable if cached and tries the API for new images
// this is necesarry because the Instagram API only allows x results from their API, this way data about
// older posts are saved to the server.
function cached_img_array($token, $userid, $hashtags)
{
	$insta_img 	= Array();
	$arrcache 	= 'cache/insta_arr.json';
	// check if cache exists
	if (file_exists($arrcache)) {
		//echo 'using cache';
		$insta_img = json_decode(file_get_contents($arrcache));
	} 
	$insta_img	= insta_img_array($insta_img, $token, $userid, $hashtags);
	// write image array to cache once an hour
	if (file_exists($arrcache) && ((time() - filemtime($arrcache)) > 60 * 60)) {
		file_put_contents($arrcache, json_encode($insta_img));
	}
	return $insta_img;
}

// returns array containing Instagram post information segmented by hashtags and userid.
function instagram_by_hashtags_and_userid($token, $userid, $hashtags)
{
	$instagram_array = cached_img_array($token, $userid, $hashtags);
	return $instagram_array;
}