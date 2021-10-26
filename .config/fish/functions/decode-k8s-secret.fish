function decode-k8s-secret --argument data
    echo -n "$data" | base64 -d
    echo
end
