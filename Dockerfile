FROM denoland/deno:2.3.7

WORKDIR config

COPY . .

CMD ["bash"]
