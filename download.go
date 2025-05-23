package main

import (
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
)

func main() {
	file, token, output := "", "", ""
	flag.StringVar(&file, "f", "DB11LITEBINIPV6", "download file")
	flag.StringVar(&token, "t", "", "download token")
	flag.StringVar(&output, "o", "a.zip", "output filename")
	flag.Parse()
	err := download(token, file, output)
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	fmt.Println("download success")
}

// download Resource file download
func download(downloadToken string, downloadFile string, outputFilename string) error {
	downloadUrl := fmt.Sprintf("https://www.ip2location.com/download/?token=%s&file=%s", downloadToken, downloadFile)
	resp, err := http.Get(downloadUrl)
	if err != nil {
		return err
	}
	defer func() { _ = resp.Body.Close() }()
	fileObject, err := os.Create(outputFilename)
	if err != nil {
		return err
	}
	defer func() { _ = fileObject.Close() }()
	_, err = io.Copy(fileObject, resp.Body)
	if err != nil {
		return err
	}
	return nil
}
