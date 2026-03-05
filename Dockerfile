FROM denoland/deno:2.7.3

WORKDIR config

COPY . .

CMD ["bash"]
