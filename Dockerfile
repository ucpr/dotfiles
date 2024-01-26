FROM denoland/deno:1.40.1

WORKDIR config

COPY . .

CMD ["bash"]
