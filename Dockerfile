FROM denoland/deno:1.40.3

WORKDIR config

COPY . .

CMD ["bash"]
