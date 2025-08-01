FROM denoland/deno:2.4.3

WORKDIR config

COPY . .

CMD ["bash"]
