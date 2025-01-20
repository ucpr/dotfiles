FROM denoland/deno:2.1.6

WORKDIR config

COPY . .

CMD ["bash"]
