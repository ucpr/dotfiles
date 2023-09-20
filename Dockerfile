FROM denoland/deno:1.37.0

WORKDIR config

COPY . .

CMD ["bash"]
