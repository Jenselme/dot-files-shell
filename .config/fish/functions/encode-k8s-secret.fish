function encode-k8s-secret --argument data
    echo -n "$data" | base64 -w 0
    echo
end
