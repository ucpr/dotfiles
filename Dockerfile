FROM denoland/deno:2.3.3

WORKDIR config

COPY . .

CMD ["bash"]
